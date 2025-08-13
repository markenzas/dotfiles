  function proxy-unset
    set -e https_proxy
    set -e http_proxy
    set -e no_proxy
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    set -e NO_PROXY
  end

  function proxy-set
    set -gx http_proxy "http://proxy-se-uan.ddc.teliasonera.net:8080"
    set -gx HTTP_PROXY "$http_proxy"
    set -gx https_proxy "$http_proxy"
    set -gx HTTPS_PROXY "$https_proxy"
    set -gx no_proxy "www.telia.se, *.teliasonera.net, .teliasonera.net, teliasonera.net, *.teliacompany.net, .teliacompany.net, teliacompany.net, localhost, 127.0.0.1"
    set -gx NO_PROXY "$no_proxy"
  end

