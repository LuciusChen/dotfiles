conf = require 'conf'

util =
  notify: (subTitle, text) =>
    unless text
      text = subTitle
      subTitle = ''
    hs.notify.show 'Hammerspoon', tostring(subTitle), tostring(text)
  getSystemPwd: ->
    hs.execute('security find-generic-password -s hammerspoon -a system -w')\gsub('%s+', '')
  reload: =>
    @notify '配置', '重新加载'
    hs.reload!
  delay: (...) ->
    hs.timer.doAfter ...
  now: ->
    hs.timer.secondsSinceEpoch!

util
