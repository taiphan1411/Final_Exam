using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO
{
    public class Item_DTO
    {
        private string madausach;
        private string tensach;
        private string bia;
        private int soluong;

        public string Madausach
        {
            get
            {
                return madausach;
            }

            set
            {
                madausach = value;
            }
        }

        public string Tensach
        {
            get
            {
                return tensach;
            }

            set
            {
                tensach = value;
            }
        }

        public string Bia
        {
            get
            {
                return bia;
            }

            set
            {
                bia = value;
            }
        }

        public int Soluong
        {
            get
            {
                return soluong;
            }

            set
            {
                soluong = value;
            }
        }

        public Item_DTO()
        {
            madausach = "";
            tensach = "";
            bia = "";
            soluong = 0;
        }
    }
}