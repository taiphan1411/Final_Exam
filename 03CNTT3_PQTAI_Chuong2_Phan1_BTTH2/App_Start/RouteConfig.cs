using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.MapRoute(
                name: "Admin",
                url: "QuanTri/{controller}/{action}",
                defaults: new { controller = "QuanLyDauSach", action = "Xem" , id = UrlParameter.Optional }
            );
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "KhoSach", action = "DuyetKhoSach", id = UrlParameter.Optional }
            );
        }
    }
}
