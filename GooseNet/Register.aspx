<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GooseNet.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        input[type=radio] {
    border: 0px;
    width: 100%;
    height: 2em;
}
        option,select{
          color:black;
        }
        form{

        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <form id="formWithDesign"action="HandleRegister.aspx" method="post">
           <h3>Register Here</h3>
        <label for="fullName">Full Name:</label>
        <input type="text" id="fullName" name="fullName" required><br><br>

        <label for="userName">Username:</label>
        <input type="text" id="userName" name="userName" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="role">Select Role:</label>
        <select id="role" name="role" required>
            <option value="coach">Coach</option>
            <option value="athlete">Athlete</option>
        </select><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <button id="formButton" type="submit">Register</button>
    </form>
</asp:Content>
