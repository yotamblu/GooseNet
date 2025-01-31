using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AthleteWorkouts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["requestedAthlete"] = Request.QueryString["athleteName"].ToString();
            
            if (!GooseNetUtils.IsConnectedToUser(Session, Session["requestedAthlete"].ToString()))
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
    }
}