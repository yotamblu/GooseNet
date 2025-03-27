using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class PlannedWorkouts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["athleteName"] == null || (!GooseNetUtils.IsConnectedToUser(Session, Request.QueryString["athleteName"]) && Session["userName"].ToString() != Request.QueryString["athleteName"].ToString()))  {

                Response.Redirect("NoAccess.aspx");
            
            }
        }
    }
}