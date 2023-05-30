using ILike.Models;
using ILike.Repository;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
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
			articlesList.Reverse();
			return Json(articlesList);
		}

		[HttpPost]
		public HttpResponseMessage GetCommentsApi([FromBody] CommentModel commentModel)
		{
			var commentM = repositoryDB.GetComment(commentModel.idArticle);

			// Явное создание экземпляра HttpResponseMessage
			var response = new HttpResponseMessage(HttpStatusCode.OK);

			// Установка содержимого ответа как сериализованный JSON из commentM
			response.Content = new StringContent(JsonConvert.SerializeObject(commentM), Encoding.UTF8, "application/json");

			return response;
		}

		[HttpPost]
		public HttpResponseMessage AddCommentApi([FromBody] CommentModel commentModel)
		{

			if (repositoryDB.AddComment(commentModel) == true)
			{
				// Возвращаем данные в формате JSON
				var response = Request.CreateResponse(HttpStatusCode.OK);
				return response;
			}
			else
			{
				return new HttpResponseMessage(HttpStatusCode.BadRequest)
				{
					Content = new StringContent("Error")
				};
			}
		}

		[HttpPost]
		public HttpResponseMessage AddUserApi([FromBody] UserModel userModel)
		{

			if (repositoryDB.AddUser(userModel) == true)
			{
				var user = repositoryDB.GetUserByLogin(userModel.Login);
				// Формируем ответ с данными пользователя
				var responseData = new
				{
					Login = user.Login,
					Email = user.Email,
					Password = user.Password,
				};

				// Возвращаем данные в формате JSON
				var response = Request.CreateResponse(HttpStatusCode.OK);
				response.Content = new StringContent(JsonConvert.SerializeObject(responseData), System.Text.Encoding.UTF8, "application/json");
				return response;
			}
			else
			{
				return new HttpResponseMessage(HttpStatusCode.BadRequest)
				{
					Content = new StringContent("Error")
				};
			}
		}

		[HttpPost]
		public HttpResponseMessage GetUserApi([FromBody] UserModel userModel)
		{

			var user = repositoryDB.GetUserByLogin(userModel.Login);

			if (user.Password == userModel.Password && user != null)
			{
				// Формируем ответ с данными пользователя
				var responseData = new
				{
					Login = user.Login,
					Email = user.Email,
					Password = user.Password,
				};

				// Возвращаем данные в формате JSON
				var response = Request.CreateResponse(HttpStatusCode.OK);
				response.Content = new StringContent(JsonConvert.SerializeObject(responseData), System.Text.Encoding.UTF8, "application/json");
				return response;
			}
			else
			{
				return new HttpResponseMessage(HttpStatusCode.BadRequest)
				{
					Content = new StringContent("Error")
				};
			}
		}
	}
}
