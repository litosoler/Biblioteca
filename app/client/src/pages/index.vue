<template>
	<!-- <search></search> -->
	<results></results>	
</template>

<script>
	import search from '@/components/search'
	import results from '@/components/results'
	export default{
		components:{search, results},
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