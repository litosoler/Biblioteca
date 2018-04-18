<template>
	<div class="container principal">
		<section class="row " >
			<div class="col-md-5 img-col">  
				<img src="@/assets/Logo.jpeg" class="img-fluid logo" alt="Bienvenido">
			</div>
			<div class="mensaje col-md-7" >
				What is Lorem Ipsum?
				Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum
			</div>
		</section>
		<section class="row search-row">
			<div class="offset-3 col-6">
				<div class="input-group mb-3">
					<input type="text" class="form-control" placeholder="Encuentra tu libro" aria-label="Recipient's username" aria-describedby="basic-addon2" autofocus>
					<div class="input-group-append green">
						<button class="btn btn-default white" type="button"><router-link to="/resultados" >Buscar</router-link></button>
					</div>
				</div>	
			</div>
			

		</section>

	</div>
</template>

<style >
.principal{
	margin-top: 30px;
}

.img-col{
	border-right: 1px solid green;
}
.search-row{
	margin-top: 40px;
}

</style>