# Fire OS Archive

## List of Fire OS devices

{% for device in devices %}
### {{ device.name }}

|:link:|Fire OS|Webview|sha256|
|:--:|:--:|:--:|:--:|
{% for version in device.versions -%}
|[:link:]({{ version.url }})|`{{ version.os_version }}`|`{{ version.webview_version }}`|`{{ version.sha256 }}`|
{% endfor -%}
{% endfor -%}
