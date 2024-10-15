<script setup>
    import WorkingTime from './WorkingTime.vue';
    var day_wts = [
        {
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },{
            start: "0",
            end: "1",
            user: "test@test.com"
        },
    ]


</script>


<template>
    <div>
        <div id="h_wrapper">
        
            <div class="v_wrapper">
                <div class="wt_wrapper" v-for="wt in day_wts">
                    <WorkingTime>

                    </WorkingTime>

                </div>
                
                
            </div>
        </div>
    </div>


</template>


<style scoped>

#h_wrapper{
    width: 100%;
    height: 100%;
    display: flex;

}

.wt_wrapper{
    width: 100%;
    height: 5em;
    background-color: blue;
    border-bottom: red;
    margin-bottom: 0.1em;
}

.v_wrapper {
    width: 100% ;
    height: calc(100% - 2px);
    border: 1px blue solid;
}


</style>
