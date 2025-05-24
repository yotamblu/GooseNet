using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AthleteSummary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null || !GooseNetUtils.IsCoachingOrIsUser(Session["userName"].ToString(), Request.QueryString["athleteName"]))
            {
                Response.Redirect("NoAccess.aspx");
            }
        }


    }
}