{% if page.comments %}
  <!--畅言插件-->
  <!-- 代码1：放在页面需要展示的位置  -->
  <!-- 如果您配置过sourceid，建议在div标签中配置sourceid、cid(分类id)，没有请忽略  -->
  <!--打赏-->
  <div id="cyReward" role="cylabs" data-use="reward" style="text-align: center;"></div>
  <!--评论表情-->
  <div id="cyEmoji" role="cylabs" data-use="emoji"></div>
  <!-- 代码2：用来读取评论框配置，此代码需放置在代码1之后。 -->
  <!-- 如果当前页面有评论框，代码2请勿放置在评论框代码之前。 -->
  <!-- 如果页面同时使用多个实验室项目，以下代码只需要引入一次，只配置上面的div标签即可 -->
  <script type="text/javascript" charset="utf-8" src="http://changyan.itc.cn/js/lib/jquery.js"></script>
  <script type="text/javascript" charset="utf-8" src="https://changyan.sohu.com/js/changyan.labs.https.js?appid=cyssdFaue"></script>

  <!--多说评论-->
  <div class="comments" id="comments">
    {% if (theme.duoshuo and theme.duoshuo.shortname) or theme.duoshuo_shortname %}
      <div class="ds-thread" data-thread-key="{{ page.path }}"
           data-title="{{ page.title }}" data-url="{{ page.permalink }}">
      </div>
    {% elseif theme.facebook_sdk.enable and theme.facebook_comments_plugin.enable %}
      <div class="fb-comments"
           data-href="{{ page.permalink }}"
           data-numposts="{{ theme.facebook_comments_plugin.num_of_posts }}"
           data-width="{{ theme.facebook_comments_plugin.width }}"
           data-colorscheme="{{ theme.facebook_comments_plugin.scheme }}">
      </div>
    {% elseif theme.disqus_shortname %}
      <div id="disqus_thread">
        <noscript>
          Please enable JavaScript to view the
          <a href="//disqus.com/?ref_noscript">comments powered by Disqus.</a>
        </noscript>
      </div>
    {% elseif theme.hypercomments_id %}
      <div id="hypercomments_widget"></div>
    {% elseif theme.gentie_productKey %}
      <div id="cloud-tie-wrapper" class="cloud-tie-wrapper"></div>
    {% endif %}
  </div>

  <!--畅言评论-->
  <section id="comments">
    <!--高速版，加载速度快，使用前需测试页面的兼容性-->
    <div id="SOHUCS" sid="{{ page.title }}"></div>
    <script>
      (function(){
        var appid = 'cysMNUGiM',//cyssdFaue
        conf = '746691ef70d87f9e0b14acf9e9f473df';//18694a97589062f29188dcc5b3c30703
        var doc = document,
        s = doc.createElement('script'),
        h = doc.getElementsByTagName('head')[0] || doc.head || doc.documentElement;
        s.type = 'text/javascript';
        s.charset = 'utf-8';
        s.src =  'http://assets.changyan.sohu.com/upload/changyan.js?conf='+ conf +'&appid=' + appid;
        h.insertBefore(s,h.firstChild);
        window.SCS_NO_IFRAME = true;
      })()
    </script>
  </section>
{% endif %}
