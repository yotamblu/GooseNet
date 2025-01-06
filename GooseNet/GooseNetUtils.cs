﻿using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class GooseNetUtils
    {
        




        public static Dictionary<string,string> GetGarminAPICredentials()
        {
            
            FirebaseService firebaseService = new FirebaseService();
            Dictionary<string, string> creds = firebaseService.GetData<Dictionary<string, string>>("GarminAPICredentials");

            return creds;
        }


        
       

    }
}