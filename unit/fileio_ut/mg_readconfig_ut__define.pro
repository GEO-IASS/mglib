; docformat = 'rst'

function mg_readconfig_ut::test_basic
  compile_opt strictarr

  config_filename = filepath('config.ini', root=mg_src_root())
  assert, file_test(config_filename), 'test configuration file not found', /skip

  config = mg_readconfig(config_filename, error=err)
  assert, err eq 0L, 'error reading configuration file: %d', err

  assert, config.haskey('foodir'), 'foodir value not present'
  assert, config['foodir'] eq '%(dir)s/whatever', $
          'invalid value for foodir: %s', config['foodir']

  assert, config.haskey('dir'), 'dir value not present'
  assert, config['dir'] eq 'frob', $
          'invalid value for dir: %s', config['dir']

  assert, config.haskey('long'), 'long value not present'
  assert, config['long'] eq 'this value continues in the next line', $
          'invalid value for long: %s', config['long']

  obj_destroy, config

  return, 1
end


function mg_readconfig_ut::test_defaults
  compile_opt strictarr

  config_filename = filepath('config.ini', root=mg_src_root())
  assert, file_test(config_filename), 'test configuration file not found', /skip

  defaults = hash('default1', 'default value 1', 'dir', 'not frob')

  config = mg_readconfig(config_filename, error=err, defaults=defaults)
  assert, err eq 0L, 'error reading configuration file: %d', err

  assert, config.haskey('default1'), 'default1 value not present'
  assert, config['default1'] eq 'default value 1', $
         'invalid value for default1: %s', config['default1']

  assert, config.haskey('foodir'), 'foodir value not present'
  assert, config['foodir'] eq '%(dir)s/whatever', $
          'invalid value for foodir: %s', config['foodir']

  assert, config.haskey('dir'), 'dir value not present'
  assert, config['dir'] eq 'frob', $
          'invalid value for dir: %s', config['dir']

  assert, config.haskey('long'), 'long value not present'
  assert, config['long'] eq 'this value continues in the next line', $
          'invalid value for long: %s', config['long']

  obj_destroy, [defaults, config]

  return, 1
end


;+
; Test array list.
;-
pro mg_readconfig_ut__define
  compile_opt strictarr

  define = { mg_readconfig_ut, inherits MGutLibTestCase }
end
