using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandlePasswordChange : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool hasProblem = false;
            string password = Request.Form["newPassword"].ToString();
            string passwordRepeat = Request.Form["passwordRepeat"].ToString();
            if(password.Length < 8)
            {
                Session["PasswordTooShortError"] = true;
                hasProblem = true;
            }
            if (!password.Equals(passwordRepeat))
            {
                Session["PasswordsDontMatchError"] = true;
                hasProblem = true;
            }
            if(hasProblem)
            {
                Response.Redirect("ChangePassword.aspx");
            }

            FirebaseService firebaseService = new FirebaseService();

            firebaseService.InsertData($"Users/{Session["userName"].ToString()}/Password", GooseNetUtils.GetSha256Hash(password));

            Response.Redirect("AccMgmtMenu.aspx");

        }
    }
}