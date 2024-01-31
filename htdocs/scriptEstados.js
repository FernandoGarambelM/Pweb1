var tarjeta_id = localStorage.getItem('tarjeta_id');
var url = "../cgi-bin/estados.pl?tarjeta_id=" + encodeURIComponent(tarjeta_id);
console.log('URL:', url);

fetch(url, {
    method: "GET",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded"
    }
})
.then(response => {
    if (response.ok) {
        return response.json();
    } else {
        throw new Error('Error en la solicitud. Estado: ' + response.status);
    }
})
.then(movimientos => {
    mostrarMovimientos(movimientos);
    generarGraficoBarras(movimientos);
})
.catch(error => {
    alert(error.message);
});


//hacer otro fetch para buscar estos datos!!!
//var inicial = document.getElementById("initial");
//var nombre = document.getElementById("name");
//var numero = document.getElementById("number");

var datoRecibido = localStorage.getItem('numero');
var nombres;
var paterno;
fetch('../cgi-bin/welcome.pl', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'numero=' + encodeURIComponent(datoRecibido)
})
.then(response => {
    if (!response.ok) {
        throw new Error('Error en la solicitud. Estado: ' + response.status);
    }
    return response.json();
})
.then(response => {
    nombres = response.nombres;
    paterno = response.paterno;
    console.log('Recibido Data:', nombres + ' ' + paterno);
    var nombre = document.getElementById("name");
    var aux = nombres + " " + paterno;
    nombre.innerHTML = aux;
    var numero = document.getElementById("number");
    numero.innerHTML = datoRecibido;
    var inicial = document.getElementById("initial");
    aux = nombres[0];
    inicial.innerHTML = aux;


})
.catch(error => {
    alert(error.message);
});





function mostrarMovimientos(movimientos) {
    var saldoTotal = document.getElementById("saldoTotal");
    var saldo = 0;
    var containerRetiros = document.getElementById("retiros");
    var containerDepositos = document.getElementById("depositos");
    var html1 = "<table>";
    html1 += "<tr><th>Monto</th><th>Realizado</th><th>Tipo</th></tr>";
    
    var html2 = "<table>";
    html2 += "<tr><th>Monto</th><th>Realizado</th><th>Tipo</th></tr>";
    
    movimientos.forEach(function(movimiento) {
        if(movimiento.tipo == 1){
            saldo += movimiento.monto;
            html1 += "<tr>";
            html1 += "<td>" + movimiento.monto + "</td>";
            html1 += "<td>" + movimiento.realizado + "</td>";
            html1 += "<td>" + obtenerTipoMovimiento(movimiento.tipo) + "</td>";
            html1 += "</tr>";
        }else{
            saldo -= movimiento.monto;
            html2 += "<tr>";
            html2 += "<td>" + movimiento.monto + "</td>";
            html2 += "<td>" + movimiento.realizado + "</td>";
            html2 += "<td>" + obtenerTipoMovimiento(movimiento.tipo) + "</td>";
            html2 += "</tr>";
        }
    });

    html1 += "</table>";
    containerDepositos.innerHTML = html1;

    html2 += "</table>";
    containerRetiros.innerHTML = html2;

    saldoTotal.innerHTML = saldo;
}


function obtenerTipoMovimiento(tipo) {
    return tipo === 1 ? "Depósito" : tipo === -1 ? "Retiro" : "Desconocido";
}

function generarGraficoBarras(movimientos) {
    // Obtener los datos para el gráfico
    var montos = movimientos.map(function(movimiento) {
        return movimiento.monto;
    });

    // Obtener etiquetas para el eje X (puede ser la fecha, el nombre, etc.)
    var etiquetas = movimientos.map(function(movimiento) {
        return movimiento.realizado;
    });

    var tipos = movimientos.map(function(movimiento) {
        return movimiento.tipo === 1 ? 'Depósito' : 'Retiro';
    });

    // Separar los montos según el tipo de movimiento
    var depositos = [];
    var retiros = [];
    montos.forEach(function(monto, index) {
        if (tipos[index] === 'Depósito') {
            depositos.push(monto);
            retiros.push(null); // Para mantener el mismo tamaño de ambos arrays
        } else {
            retiros.push(monto);
            depositos.push(null); // Para mantener el mismo tamaño de ambos arrays
        }
    });

    // Configurar los datos del gráfico
    var data = {
        labels: etiquetas,
        datasets: [{
            label: 'Depósito',
            backgroundColor: 'rgba(255, 99, 132, 0.2)', // Color para depósitos
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1,
            data: depositos
        },
        {
            label: 'Retiro',
            backgroundColor: 'rgba(54, 162, 235, 0.2)', // Color para retiros
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1,
            data: retiros
        }]
    };

    var options = {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        }
    };

    // Obtener el contexto del lienzo
    var ctx = document.getElementById('grafico').getContext('2d');

    // Crear el gráfico de barras
    var chart = new Chart(ctx, {
        type: 'bar',
        data: data,
        options: options
    });
}


