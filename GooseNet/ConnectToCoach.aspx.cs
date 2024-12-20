using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class ConnectToCoach : System.Web.UI.Page
    {


        public void CheckForAccess()
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckForAccess();
            if (Session["role"].ToString() == "coach")
            {
                Response.Redirect("NoAccess.aspx");
            }
        }


       
    }
}