<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="GooseNet.Error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <title>Oops! Something Went Wrong</title>
    <style>
      
        
    .container{
        width:50vw;
        height:50vh;
        background-color:white;
        border-radius:30px;
    }
    .container *,.container{
                color:black;
                font-size:4vw;
    }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <center> <div class="container">Oops! <br /> <span>Something Went Wrong!</span>  <br /><br />  <button style="padding-top:0;"  class="workoutBtns"><a href="HomePage.aspx">Go Back To Home</a></button>
</div></center>
</asp:Content>
