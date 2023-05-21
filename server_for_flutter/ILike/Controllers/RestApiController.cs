using ILike.Models;
using ILike.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;


namespace ILike.Controllers
{
    public class RestApiController : ApiController
    {
		RepositoryDB repositoryDB = new RepositoryDB();
		[HttpGet]
		public IHttpActionResult GetArticlesApi()
		{
			var articlesList = repositoryDB.GetArticle();
			return Json(articlesList);
		}
	}
}
