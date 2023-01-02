#!/usr/bin/env rspec
# frozen_string_literal: true

require 'spec_helper'

provider_class = Puppet::Type.type(:mailalias).provider(:augeas)

def fullquotes_supported?
  # This lens breaks on Augeas 0.10.0
  Puppet::Util::Package.versioncmp(Puppet::Type.type(:mailalias).provider(:augeas).aug_version, '0.10.0') > 0
end

describe provider_class do
  before do
    FileTest.stubs(:exist?).returns false
    FileTest.stubs(:exist?).with('/etc/aliases').returns true
  end

  context 'with empty file' do
    let(:tmptarget) { aug_fixture('empty') }
    let(:target) { tmptarget.path }

    it 'creates simple new entry' do
      apply!(Puppet::Type.type(:mailalias).new(
               name: 'foo',
               recipient: 'bar',
               target: target,
               provider: 'augeas'
             ))

      aug_open(target, 'Aliases.lns') do |aug|
        aug.get('./1/name').should eq('foo')
        aug.get('./1/value').should eq('bar')
      end
    end

    it 'creates two new entries' do
      apply!(
        Puppet::Type.type(:mailalias).new(
          name: 'foo',
          recipient: 'bar',
          target: target,
          provider: 'augeas'
        ),
        Puppet::Type.type(:mailalias).new(
          name: 'bar',
          recipient: 'baz',
          target: target,
          provider: 'augeas'
        )
      )

      aug_open(target, 'Aliases.lns') do |aug|
        aug.match('*/name').size.should == 2
      end
    end

    it 'creates new entry' do
      apply!(Puppet::Type.type(:mailalias).new(
               name: 'foo',
               recipient: %w[foo-a foo-b],
               target: target,
               provider: 'augeas'
             ))

      aug_open(target, 'Aliases.lns') do |aug|
        aug.get('./1/name').should eq('foo')
        aug.match('./1/value').size.should eq(2)
        aug.get('./1/value[1]').should eq('foo-a')
        aug.get('./1/value[2]').should eq('foo-b')
      end
    end

    # Ticket #41
    context 'when full quotes are supported', if: fullquotes_supported? do
      it 'creates new entry with quotes' do
        apply!(Puppet::Type.type(:mailalias).new(
                 name: 'users-leave',
                 recipient: '| /var/lib/mailman/mail/mailman leave users',
                 target: target,
                 provider: 'augeas'
               ))

        aug_open(target, 'Aliases.lns') do |aug|
          aug.get('./1/name').should eq('users-leave')
          aug.get('./1/value').should eq('"| /var/lib/mailman/mail/mailman leave users"')
        end
      end
    end
  end

  context 'with full file' do
    let(:tmptarget) { aug_fixture('full') }
    let(:target) { tmptarget.path }

    it 'lists instances' do
      provider_class.stubs(:target).returns(target)
      inst = provider_class.instances.map do |p|
        {
          name: p.get(:name),
          ensure: p.get(:ensure),
          recipient: p.get(:recipient),
        }
      end

      inst.size.should eq(3)
      inst[0].should eq({ name: 'mailer-daemon', ensure: :present, recipient: ['postmaster'] })
      inst[1].should eq({ name: 'postmaster', ensure: :present, recipient: ['root'] })
      inst[2].should eq({ name: 'test', ensure: :present, recipient: %w[user1 user2] })
    end

    it 'deletes entries' do
      apply!(Puppet::Type.type(:mailalias).new(
               name: 'mailer-daemon',
               ensure: 'absent',
               target: target,
               provider: 'augeas'
             ))

      aug_open(target, 'Aliases.lns') do |aug|
        aug.match("*[name = 'mailer-daemon']").should == []
      end
    end

    describe 'when updating recipients' do
      it 'replaces a recipients' do
        apply!(Puppet::Type.type(:mailalias).new(
                 name: 'mailer-daemon',
                 recipient: ['test'],
                 target: target,
                 provider: 'augeas'
               ))

        aug_open(target, 'Aliases.lns') do |aug|
          aug.get('./1/name').should eq('mailer-daemon')
          aug.match('./1/value').size.should eq(1)
          aug.get('./1/value').should eq('test')
        end
      end

      it 'adds multiple recipients' do
        apply!(Puppet::Type.type(:mailalias).new(
                 name: 'mailer-daemon',
                 recipient: %w[test-a test-b],
                 target: target,
                 provider: 'augeas'
               ))

        aug_open(target, 'Aliases.lns') do |aug|
          aug.get('./1/name').should eq('mailer-daemon')
          aug.match('./1/value').size.should eq(2)
          aug.get('./1/value[1]').should eq('test-a')
          aug.get('./1/value[2]').should eq('test-b')
        end
      end

      # Ticket #41
      context 'when full quotes are supported', if: fullquotes_supported? do
        let(:tmptarget) { aug_fixture('fullquotes') }
        let(:target) { tmptarget.path }

        it 'updates entry with quotes' do
          apply!(Puppet::Type.type(:mailalias).new(
                   name: 'users-leave',
                   recipient: '| /var/lib/mailman/mail/mailman leave userss',
                   target: target,
                   provider: 'augeas'
                 ))

          aug_open(target, 'Aliases.lns') do |aug|
            aug.get('./4/name').should eq('users-leave')
            aug.get('./4/value').should eq('"| /var/lib/mailman/mail/mailman leave userss"')
          end
        end
      end
    end
  end

  context 'with broken file' do
    let(:tmptarget) { aug_fixture('broken') }
    let(:target) { tmptarget.path }

    it 'fails to load' do
      expect do
        apply(Puppet::Type.type(:mailalias).new(
                name: 'foo',
                recipient: 'bar',
                target: target,
                provider: 'augeas'
              ))
      end.to raise_error(RuntimeError, %r{Augeas didn't load})
    end
  end
end
