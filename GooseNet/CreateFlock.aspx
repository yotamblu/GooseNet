<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CreateFlock.aspx.cs" Inherits="GooseNet.CreateFlock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>

    form {
    position: relative;
    width: fit-content;
    background-color: rgba(255,255,255,0.13);
    margin: auto;
    margin-top:13vh;
    top: initial;
    left: initial;
    transform: none;
    border-radius: 10px;
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255,255,255,0.1);
    box-shadow: 0 0 40px rgba(8,7,16,0.6);
    padding: 5vw 20vh;
}
    </style>

    <title>Create Flock</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%HandleFlockExistsError(); %>
    <form method="post" action="HandleFlockCreation.aspx">
        <h1 style="font-size:4vw;">Create Flock</h1>
        <b style="font-size:1vw;">Flock Name</b><br />
        <input style="width:20vw;" name="FlockName" /><br /><br />
        <br /><br /><br /><br />
            <button type="submit">Submit</button>

    </form>


</asp:Content>
