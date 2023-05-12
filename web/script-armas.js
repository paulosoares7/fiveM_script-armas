
const images = {
    plates: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651975248035961/placa-metal.png',
    parts: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651964854534165/corpo-ak47.png',
    springs: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651972001636382/molas.png',
    kitten: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651971200532500/gatilho.png',
}

const weaponsList = [
    {
        name: 'AK47',
        items:{
            plates : 5,
            parts: 2,
            springs: 2,
            kitten: 1
        },
        image: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651720179826790/ak47.png',
        action: 'produzir-ak47'
    },
    {
        name: 'Tec - 9',
        items:{
            plates : 4,
            parts: 3,
            springs: 1,
            kitten: 1
        },
        image: 'https://media.discordapp.net/attachments/758889960269938722/1101651975545819186/tec9.png',
        action: 'produzir-tec9'
    },
    {
        name: 'M4spec',
        items:{
            plates : 6,
            parts: 3,
            springs: 2,
            kitten: 1
        },
        image: 'https://cdn.discordapp.com/attachments/758889960269938722/1104252005813330070/g36c.png',
        action: 'produzir-m4spec'
    },
    {
        name: 'Fiveseven',
        items:{
            plates : 2,
            parts: 2,
            springs: 1,
            kitten: 1
        },
        image: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651966108639282/fiveseven.png',
        action: 'produzir-fiveseven'
    },
    {
        name: 'Hk',
        items:{
            plates : 2,
            parts: 2,
            springs: 1,
            kitten: 1
        },
        image: 'https://cdn.discordapp.com/attachments/758889960269938722/1101651971640922162/hk.png',
        action: 'produzir-pistolhk'
    },
]

const containerList = document.querySelector('#list')
function render(weaponsList) {
    let list = ``

    weaponsList.forEach(weapon => {
        list += `
        <div class="content">
            <div class="itemName">
                <img src=${weapon.image}>
                <h3> ${weapon.name} </h3>
            </div>
            
            <div class="itemDescription">
                <div class="needs"><p>Você precisa de:</p></div>
                <ul>
                    <li>
                        <div class="infoBox">
                            <img src=${images.plates} >
                            <p> ${weapon.items.plates}x Placas de metal</p>
                        </div>
                    </li>
                    <li>
                        <div class="infoBox">
                            <img src=${images.springs} >
                            <p> ${weapon.items.springs}x Molas</p>
                        </div>
                    </li>
                    <li>
                        <div class="infoBox">
                            <img src= ${images.parts} >
                            <p> ${weapon.items.parts}x Peça de arma</p>
                        </div>
                    </li>
                    <li>
                        <div class="infoBox">
                            <img src=${images.kitten} >
                            <p> ${weapon.items.kitten}x gatilhos </p>
                        </div>
                    </li>
                </ul>
            </div>
            <button class="btn" data-action = ${weapon.action}> Produzir </button>
         </div>

        `
    });

    containerList.innerHTML = list
}
render(weaponsList)


$(document).ready(function(){
    const btn = $('.btn')
    const body = $('body')
    const container = $('.container')

    function sendData(event, data){
        $.post(
            `http://script-armas/${event}`,
            JSON.stringify(data),
            function (datab){
                if ( datab != 'ok'){
                    console.log(datab)
                }
            }
        )
    }
    
    $(this).on('keyup',function(e){
        const contentActive = container.is(':visible')
        const esc = e.which

       
        if( esc === 27 && contentActive === true){
            sendData('ButtonClick', 'fechar-menu')
        }
    })

    window.addEventListener('message', function(e){
        const message = e.data
        
        if (message.showMenu) {
            body.css('background', 'rgba(0, 0, 0, 0.15)').fadeIn(100)
            container.css('display', 'block')
        }
        if (message.hideMenu) {
            body.css('background', 'transparent').fadeOut(100)
            container.css('display', 'none')
        }
    })
    
    btn.on('click', function(){
        const thisBtn = $(this)
        const action = thisBtn.data('action')
        sendData('ButtonClick',action)
    })
})