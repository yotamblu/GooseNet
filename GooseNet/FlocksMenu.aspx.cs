using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class FlocksMenu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null || Session["role"].ToString() != "coach")
            {
                Response.Redirect("noAccess.aspx");
            }



        }


        protected void ShowMyFlocksBtn()
        {
            if(new FirebaseService().GetData<Flock>($"Flocks/{Session["userName"].ToString()}") != null)
            {
                Response.Write("  <button style=\"margin-right:10vw;transform:scale(2)\"><a href=\"MyFlocks.aspx\">My Flocks</a></button>");
            }
        }


   
    }
}