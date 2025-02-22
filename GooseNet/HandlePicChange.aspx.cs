using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandlePicChange : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            FirebaseService firebaseService = new FirebaseService();
            string newPicString;

            if (Request.QueryString["revertToDefault"] != null)
            {
                newPicString = firebaseService.GetData<User>($"Users/{Session["userName"]}").DefualtPicString;
            }
            else
            {
                newPicString = Request.Form["base64Output"].ToString();
            }
            Session["picString"] = newPicString;
            firebaseService.InsertData($"Users/{Session["userName"]}/ProfilePicString", newPicString);
            Response.Redirect("AccMgmtMenu.aspx");

        }
    }
}