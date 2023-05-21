using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ILike.Models
{
	public class Article
	{
		public int id { get; set; }	
		public string title { get; set; }
		public string imageUrl { get; set; }
		public string content { get; set; }
	}
}