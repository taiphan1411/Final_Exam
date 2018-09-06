﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class QuanLyCaNhanController : Controller
    {
        // GET: QuanLyCaNhan
        public ActionResult Xem()
        {
            if (Session["phanquyen"] != "a" && Session["phanquyen"] != "u")
            {
                return Redirect("/TrangChu/Xem");
            }
            return View("~/Views/Library/QuanLyCaNhan/Xem.cshtml");
        }
    }
}