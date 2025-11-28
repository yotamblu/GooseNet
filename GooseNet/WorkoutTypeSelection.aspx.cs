using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class WorkoutTypeSelection : System.Web.UI.Page
    {


        protected string GetTargetParam()
        {
            bool isFlock = Request.QueryString["flockName"] != null;
            if (isFlock)
            {
                return $"?flockName={Request.QueryString["flockName"]}";
            }
            return $"?athleteName={Request.QueryString["athleteName"]}";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
    }
}