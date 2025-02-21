using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class CreateFlock : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null || Session["role"].ToString() != "coach")
            {
                Response.Redirect("noAccess.aspx");
            }

        }

        protected void HandleFlockExistsError()
        {
            if (Session["flockExistsError"] != null && (bool)Session["flockExistsError"])
            {
                Response.Write("<error>You Already Have a Flock Named that, Pick a different name and Try Again!</error>");
                Session["flockExistsError"] = null;
            }
        }
    }
}