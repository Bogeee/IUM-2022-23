window.onload = function() {
    document.getElementById("errMsg").style.display = 'none';
    document.getElementById("register-form").onsubmit = function(event) {
        document.getElementById("errMsg").style.display = 'none';
        event.preventDefault();
        formDataChannel.postMessage(getFormData());
        return false;
    }
}

function getFormData() {
    var data = {};
    var radioChecked = {};
    var radioValidated = false;  
    var form = document.getElementById("register-form");

    for(var i = 0; i < form.elements.length; i++) {
        var element = form.elements[i];

        if(element.value == "") {
            if(element.name == "first-name") {
                showError("Devi inserire il nome.");
                element.focus();
                return false;
            } else if(element.name == "last-name") {
                showError("Devi inserire il cognome.");
                element.focus();
                return false;
            } else if(element.name == "age") {
                showError("Devi inserire l'età.");
                element.focus();
                return false;
            } else if(element.name == "email") {
                showError("Devi inserire l'email.");
                element.focus();
                return false;
            } else if(element.name == "rpt-email") {
                showError("Devi reinserire l'email.");
                element.focus();
                return false;
            } else if(element.name == "password") {
                showError("Devi inserire la password.");
                element.focus();
                return false;
            } else if(element.name == "rpt-password") {
                showError("Devi reinserire la password.");
                element.focus();
                return false;
            }
        }

        if (!radioValidated) {
            if (element.type == "radio") {
                radioChecked[element.id] = element.checked;
            }
            
            var radioButtons = 0;
            var radioOk = false;
            var radioChosen;
            
            for(var el in radioChecked) {
                radioButtons++;
                if(radioChecked[el]) {
                    radioOk = true;
                    radioChosen = el;
                }
            }
            
            if(radioButtons == 3) {
                if (!radioOk) {
                    showError("Devi selezionare un sesso.");
                    return false;
                } else {
                    data[element.name] = document.getElementById(radioChosen).value;
                    radioValidated = true;
                }
            }
        }

        if(element.type == "email") {
            var regexEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            if(!regexEmail.test(element.value)) {
                showError("Devi inserire un indirizzo email valido.");
                element.focus();
                return false;
            }
        } else if (element.type == "password") {
            var regexPwd = new RegExp(
              "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*[a-zA-Z]).{8,}$"
            );

            if(!regexPwd.test(element.value)) {
                showError("Devi inserire una password con almeno 8 caratteri, almeno una maiuscola, almeno una minuscola, almeno un numero e almeno un carattere speciale (tra !@#$%^&*).");
                element.focus();
                return false;
            }
        }
        
        if (element.type != "submit" && element.type != "radio")
            data[element.name] = element.value;
    }

    if(data["email"] != data["rpt-email"]) {
        showError("Le due email non coincidono.");
        return false;
    }

    if(data["password"] != data["rpt-password"]) {
        showError("Le due password non coincidono.");
        return false;
    }

    return JSON.stringify(data);
}

function showError(message) {
    var errDiv = document.getElementById("errMsg");
    errDiv.innerHTML = message;
    errDiv.style.display = 'block';
    errDiv.className = 'error-message';
}

function showResult(message) {
    var errDiv = document.getElementById("errMsg");
    errDiv.innerHTML = message;
    errDiv.style.display = 'block';
    errDiv.className = 'success-message';
}