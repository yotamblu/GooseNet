using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!GooseNetUtils.IsLoggedIn(Session))
            {
                Response.Redirect("NoAccess.aspx");
            }
        }

        protected void ShowErrorMessages()
        {
            if (Session["PasswordsDontMatchError"] != null && (bool)Session["PasswordsDontMatchError"])
            {
                Response.Write("<error>Passwords Must Match</error><br/>");
                Session["PasswordsDontMatchError"] = null;
            }
            if (Session["PasswordTooShortError"] != null && (bool)Session["PasswordTooShortError"])
            {
                Response.Write("<error>Password Must be 8 Characters or Longer!</error><br/>");
                Session["PasswordTooShortError"] = null;
            }
        }
    }
}