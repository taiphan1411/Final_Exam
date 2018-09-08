using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO
{
    public class ChiTietDonMuonSach_DTO
    {
        private string machitietdonmuonsach;
        private string madonmuonsach;
        private string madausach;
        private int soluong;

        public string Machitietdonmuonsach
        {
            get
            {
                return machitietdonmuonsach;
            }

            set
            {
                machitietdonmuonsach = value;
            }
        }

        public string Madonmuonsach
        {
            get
            {
                return madonmuonsach;
            }

            set
            {
                madonmuonsach = value;
            }
        }

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

        public ChiTietDonMuonSach_DTO()
        {
            this.machitietdonmuonsach = "";
            this.madonmuonsach = "";
            this.madausach = "";
            this.soluong = 0;
    }
    }
}