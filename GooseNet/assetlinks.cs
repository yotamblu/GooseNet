using System;
using System.Web;

public class AssetLinksHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        string assetLinksJson = @"
[
  {
    ""relation"": [""delegate_permission/common.handle_all_urls""],
    ""target"": {
      ""namespace"": ""android_app"",
      ""package_name"": ""com.example.goosenetmobile"",
      ""sha256_cert_fingerprints"": [
        ""F2:A7:EF:3D:72:31:67:34:31:30:6F:21:8B:CC:B1:93:CC:CF:F7:D2:01:F1:06:EC:78:D0:F4:93:60:6B:C4:B5""
      ]
    }
  }
]
";

        context.Response.Write(assetLinksJson);
    }

    public bool IsReusable => false;
}
