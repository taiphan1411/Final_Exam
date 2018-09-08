using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
        protected void Application_End()
        {
        }
        protected void Session_Start()
        {
            Session.Add("manguoidung","");
            Session.Add("hovaten","");
            Session.Add("phanquyen","u");
            Session.Add("anhdaidien","");

            if (Request.Cookies["tendangnhap"] != null && Request.Cookies["matkhau"] != null)
            {
                string tendangnhap = Request.Cookies["tendangnhap"].Value;
                string matkhau = Request.Cookies["matkhau"].Value;

                NguoiDung_DTO nguoidung = NguoiDung_BUS.LayThongTinNguoiDungBoiUsernameVaPassword(tendangnhap, matkhau);
                if (nguoidung != null)
                {
                    Session["manguoidung"] = nguoidung.Manguoidung;
                    Session["hovaten"] = nguoidung.Hovaten;
                    Session["phanquyen"] = nguoidung.Phanquyen;
                    Session["anhdaidien"] = nguoidung.Anhdaidien;
                }
            }
            else
            {
                Session["manguoidung"] = "";
                Session["hovaten"] = "";
                Session["phanquyen"] = "u";
                Session["anhdaidien"] = "";
            }
        }
        protected void Session_End()
        {
            Session.Clear();
        }
        protected void Application_BeginRequest()
        {
        }
        
        protected void Application_EndRequest()
        {

        }
    }
}
