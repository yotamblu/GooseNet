using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class WorkoutLibrary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected string GetTargetParam()
        {
            bool isFlock = Request.QueryString["flockName"] != null;
            if (isFlock)
            {
                return $"&flockName={Request.QueryString["flockName"]}";
            }
            return $"&athleteName={Request.QueryString["athleteName"]}";
        }
    }
}