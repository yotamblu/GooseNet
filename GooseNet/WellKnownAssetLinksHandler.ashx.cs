using System;
using System.Web;

namespace GooseNet
{
    public class WellKnownAssetLinksHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string json = @"[
  {
    ""relation"": [""delegate_permission/common.handle_all_urls""],
    ""target"": {
      ""namespace"": ""android_app"",
      ""package_name"": ""com.example.goosenetmobile"",
      ""sha256_cert_fingerprints"": [
        ""F3:E0:72:D8:93:77:5C:C1:46:D5:43:B1:33:8F:74:A2:53:78:75:E9:6B:9E:82:00:87:AB:86:F8:C4:99:ED:86""
      ]
    }
  }
]";
            context.Response.Write(json);
        }

        public bool IsReusable => false;
    }
}
