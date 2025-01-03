using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class GeneralMethods
    {

        public static Dictionary<string,string> GetGarminApiCredentials()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";
            Dictionary<string, string> creds = new Dictionary<string, string>();
            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM GarminAPICredentials");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader dr = cmdObj.ExecuteReader();
            while(dr.Read())
            {
                creds.Add("ConsumerKey", dr["ConsumerKey"].ToString());
                creds.Add("ConsumerSecret", dr["ConsumerSecret"].ToString());
                //creds["ConsumerKey"] = dr["ConsumerKey"].ToString();
                //creds["ConsumerSecret"] = dr["ConsumerSecret"].ToString();
            }
            

            conObj.Close();
            return creds;
        }

    }
}