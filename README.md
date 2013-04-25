# fluent-plugin-zoomdata

A fluent output plugin for sending json to Zoomdata server

see [zoomdata][1](zoomdata.com)

## Configuration

```
  <match example.*>
    type zoomdata
    endpoint_url https://localhost:443/zoomdata-web/service/upload
    ssl          true
    sourcename   testsource
    username     user
    password     pass
  </match>
```

## Copyright
* Copyright (c) 2013- Jun Ohtani
* License
  * Apache License, Version 2.0

[1]: http://zoomdata.com

