using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public class User
    {
        public string UserName { get; set; }
        public string FullName {  get; set; }
        public string Role {  get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string ProfilePicString {  get; set; }
        public string DefualtPicString {  get; set; }




    }
}