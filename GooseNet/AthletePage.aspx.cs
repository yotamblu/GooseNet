using System;
using System.Collections.Generic;
using System.EnterpriseServices;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AthletePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckAccess();
        }


        private void CheckAccess()
        {
            if (!GooseNetUtils.IsConnectedToUser(Session, Request.QueryString["athleteName"]) || Session["userName"].ToString() == Request.QueryString["athleteName"])
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
    }
}