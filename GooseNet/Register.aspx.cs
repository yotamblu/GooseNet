using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void HandleUserNameTakenError()
        {
            if (Session["UserNameTakenError"] != null && (bool)Session["UserNameTakenError"])
            {
                Response.Write("<error>Error:UserName is taken please try again </erorr>");
            }
            Session["UserNameTakenError"] = null;
        }

    }
}