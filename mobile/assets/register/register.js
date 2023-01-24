window.onload = function() {
    // document.getElementById("errMsg").style.display = 'none';
    document.getElementById("register-form").onsubmit = function(event) {
        event.preventDefault();
        var errDiv = document.getElementById("errMsg");
        errDiv.style.display = 'none';
        document.getElementById("btnRegister").insertAdjacentElement("beforebegin", errDiv);
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
                showError(element, "Devi inserire il nome.");
                return false;
            } else if(element.name == "last-name") {
                showError(element, "Devi inserire il cognome.");
                return false;
            } else if(element.name == "age") {
                showError(element, "Devi inserire l'età.");
                return false;
            } else if(element.name == "email") {
                showError(element, "Devi inserire l'email.");
                return false;
            } else if(element.name == "rpt-email") {
                showError(element, "Devi reinserire l'email.");
                return false;
            } else if(element.name == "password") {
                showError(element, "Devi inserire la password.");
                return false;
            } else if(element.name == "rpt-password") {
                showError(element, "Devi reinserire la password.");
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
                    showError(element, "Devi selezionare un sesso.");
                    return false;
                } else {
                    data[element.name] = document.getElementById(radioChosen).value;
                    radioValidated = true;
                }
            }
        }

        if(element.type == "number") {
            if(element.value < 14 || element.value > 90) {
                showError(element, "L'età ammessa è da 14 a 90.");
                return false;
            }
        }

        if(element.type == "email") {
            var regexEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            if(!regexEmail.test(element.value)) {
                showError(element, "Devi inserire un indirizzo email valido.");
                return false;
            }
        } else if (element.type == "password") {
            var regexPwd = new RegExp(
              "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*[a-zA-Z]).{8,}$"
            );

            if(!regexPwd.test(element.value)) {
                showError(element, "Devi inserire una password con almeno 8 caratteri, almeno una maiuscola, almeno una minuscola, almeno un numero e almeno un carattere speciale (tra !@#$%^&*).");
                return false;
            }
        }
        
        if (element.type != "submit" && element.type != "radio")
            data[element.name] = element.value;
        
        clearAriaErrorAttributes(element.name);
    }

    if(data["email"] != data["rpt-email"]) {
        setErrorMessage("Le due email non coincidono.");
        setAriaErrorAttributes("email");
        setAriaErrorAttributes("rpt-email");
        return false;
    }

    clearAriaErrorAttributes("email");
    clearAriaErrorAttributes("rpt-email");

    if(data["password"] != data["rpt-password"]) {
        setErrorMessage("Le due password non coincidono.");
        setAriaErrorAttributes("password");
        setAriaErrorAttributes("rpt-password");
        return false;
    }

    clearAriaErrorAttributes("password");
    clearAriaErrorAttributes("rpt-password");

    return JSON.stringify(data);
}

function setAriaErrorAttributes(elementName) {
    var errMsg = document.getElementById("errMsg");
    if(elementName != "gender") {
        document.getElementsByName(elementName).forEach((element) => {
          element.setAttribute("aria-invalid", "true");
          element.setAttribute("aria-describedby", "errMsg");
          element.insertAdjacentElement("afterend", errMsg);
        });
    } else {
        document.getElementsByName(elementName).forEach((element) => {
          element.setAttribute("aria-invalid", "true");
          element.setAttribute("aria-describedby", "errMsg");
        });

        document.getElementById("radio-container").insertAdjacentElement("afterend", errMsg);
    }
}

function clearAriaErrorAttributes(elementName) {
    document.getElementsByName(elementName).forEach((element) => {
      element.removeAttribute("aria-invalid");
      element.removeAttribute("aria-describedby");
    });
}

function showError(element, message) {
    setErrorMessage(message);
    setAriaErrorAttributes(element.name);
    element.focus();
}

function setErrorMessage(message) {
    var errDiv = document.getElementById("errMsg");
    errDiv.innerHTML = message;
    errDiv.style.display = "block";
    errDiv.className = "error-message";
}

function showResult(message) {
    var errDiv = document.getElementById("errMsg");
    errDiv.innerHTML = message;
    errDiv.style.display = 'block';
    errDiv.className = 'success-message';
}