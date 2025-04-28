using System;
using System.Collections.Generic;
using BenzinskaPumpa.Shared;
using DL_SlojPodataka;
using BenzinskaPumpa.Shared;
using static DL_SlojPodataka.DLBenzinskaPumpa;
using static BL_PoslovnaLogika.BLUsluga;

namespace BL_PoslovnaLogika
{
    public class BLUsluga
    {
        private DLBenzinskaPumpa dl = DLBenzinskaPumpa.Instance;

        private static BLUsluga instance = null;
        public static BLUsluga Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new BLUsluga();
                }
                return instance;
            }
        }

        public List<Usluga> GetUsluge()
        {
            return dl.GetAll();
        }

        public Usluga GetUsluga(int id)
        {
            return dl.GetById(id);
        }

        public List<Usluga> GetUslugeByKategorija(int kategorijaID)
        {
            return DLBenzinskaPumpa.Instance.GetUslugeByKategorija(kategorijaID);
        }


        public bool InsertUsluga(Usluga u)
        {
            return dl.Insert(u);
        }

        public bool UpdateUsluga(Usluga u)
        {
            return dl.Update(u);
        }

        public bool DeleteUsluga(int id)
        {
            return dl.Delete(id);
        }

        

        

    }
}

