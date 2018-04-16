<template>
	<!-- <search></search> -->
	<!-- <results></results> -->
	<!-- <registro-cliente></registro-cliente> -->
	<!-- <historial-compras></historial-compras> -->
	<!-- <historial-prestamos></historial-prestamos> -->
	<historial-puntos></historial-puntos>

</template>

<script>
	import search from '@/components/search'
	import results from '@/components/results'
	import registroCliente from '@/components/registroCliente'
	import historialPrestamos from '@/components/historialPrestamos'
	import historialCompras from '@/components/historialCompras'
	import historialPuntos from '@/components/historialPuntos'
	export default{
		components:{search, results, registroCliente, historialCompras, historialPrestamos, historialPuntos},
	}
</script>
<style>
.principal{
	margin-top: 30px;
}

.img-col{
	border-right: 1px solid green;
}
.search-row{
	margin-top: 40px;
}
.toolbar{
	background-color: #3378C5;
}
</style>