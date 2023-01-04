# frozen_string_literal: true
#

require 'augeas_spec'

# workaround for broken autoloader:
$LOAD_PATH.unshift(File.join(__dir__, 'fixtures/modules/augeasproviders_core/lib'))
$LOAD_PATH.unshift(File.join(__dir__, 'fixtures/modules/host_core/lib'))
$LOAD_PATH.unshift(File.join(__dir__, 'fixtures/modules/mailalias_core/lib'))

