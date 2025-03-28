﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class LogIn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (GooseNetUtils.IsLoggedIn(Session))
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
    }
}