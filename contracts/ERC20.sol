//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf (address account) external view returns (uint256);

    function transfer (address to, uint256 amount) external returns (bool);

    function allowance (address owner, address spender) external view returns (uint256);

    function approve (address spender, uint256 amount) external returns (bool);

    function transferFrom (address from, address to, uint256 amount) external returns (bool);


    event Transfer (address indexed from, address indexed to, uint256 amount);
    event Approval (address indexed from, address indexed to, uint256 amount);

}


contract ERC20  is IERC20  {

    //Variables

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address=>uint256)) private _allowances;

    uint256 private _totalSupply; // Para ver los tokens en circulacion
    string private _name;  //Example Ethereum
    string private _symbol;  // Example ETH


    //Las _ en las variables se ponen primero por que son privadas, como arriba, despues las publicas se poenen despues , por convenio para diferenciar se hace asi
    constructor (string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }


    // Funcion para devolver el nombre de nuestro token
    //Virtual es por si alguien quiere utilizar nuestro contrato, esta funcion o varias, para ser padre
    function name () public view  virtual returns  (string memory) {
        return _name; 
    }

    // Funcion para devolver el simbolo de nuestro token
     function symbol () public view  virtual returns  (string memory) {
        return _symbol; 
    }

    // Funcion para que haya decimales en nuestros tokens, siempre se pone 18
    function decimals () public view virtual returns (uint8){
        return 18;
    }




    //Funciones interfaz, es decir arriba

    //Override significa que vamos a redifinir la funcion que hemos definido en la interfaz del token, es decir, arriba
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf (address account) public view virtual override returns (uint256){
        return _balances[account];
    }

    function transfer (address to, uint256 amount) public virtual override returns (bool){
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    //Funcion para sacar info del owner y del que va a meter dinero
    function allowance (address owner, address spender) public view virtual override returns (uint256){
        return _allowances [owner][spender];
    }

    function approve (address spender, uint256 amount) public  virtual override returns (bool){
        address owner = msg.sender;
        _approve (owner, spender, amount);
        return true;
    }

    function transferFrom (address from, address to, uint256 amount) public virtual override returns (bool){
        address spender = msg.sender;
        _spendAllowance (from, spender, amount);
        _transfer(from, to, amount);

        return true;
    }

    // Funcion incrementar tokens del spender cedidos
    function increaseAllowance (address spender, uint256 addedValue) public virtual returns (bool){
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;

    }

    function decreaseAllowance (address spender, uint256 subtractedValue) public virtual returns (bool){
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);

        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance velor zero");

        unchecked{
            _approve (owner, spender, currentAllowance-subtractedValue);
        }

        return true;
    }







    // Funciones Internas
    function _transfer (address from, address to, uint256 amount) internal virtual {
        require (from!= address(0), "ERC:20 transfer from the zero address"); //Verificamos que la addres no sea la cuenta 0
        require (to!= address(0), "ERC:20 transfer to the zero address"); //Verificamos que la addres no sea la cuenta 0

         _beforeTokenTransfer (from, to, amount);

        //Verificamos
        uint256 fromBalance = _balances[from];
        require (fromBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            _balances [from] = fromBalance-amount;
        }

        _balances[to]+=amount;
        emit Transfer (from, to, amount);

         _afterTokenTransfer (from, to, amount);

    }

    function _approve (address owner, address spender, uint256 amount) internal virtual {
        require (owner!= address(0), "ERC:20 transfer from the zero address"); //Verificamos que la addres no sea la cuenta 0
        require (spender!= address(0), "ERC:20 transfer to the zero address"); //Verificamos que la addres no sea la cuenta 0

        _allowances[owner][spender] = amount;

        emit Approval (owner, spender, amount); (owner, spender,  amount);
    }


    function _spendAllowance (address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance (owner, spender);

        if(currentAllowance != type(uint256).max){     //Comprobamos que el spender tenga la cantidad de tokens correcta
            require(currentAllowance >= amount, "ERC:20 insufficient balance" );
            unchecked{
                _approve(owner, spender, currentAllowance-amount);
            }
        }
    }


    // Funcion para generar tokens nuevos
    function _mint (address account, uint256 amount) internal virtual {
        require (account != address (0), "ERC20: mint to the zero address");

        _beforeTokenTransfer (address(0), account, amount);
        _totalSupply += amount;
        unchecked{
            _balances[account]+=amount;
        }

        emit Transfer(address(0), account, amount);

         _afterTokenTransfer (address(0), account, amount);
    }


    // Funcion que destruye/quema tokens
    function _burn (address account, uint256 amount) internal virtual {
        require (account != address(0), "ERC20: burn from the zero address");

         _beforeTokenTransfer (address(0), account, amount);

        uint256 accountBalance = _balances[account];
        require (accountBalance>=amount, "ERC:20 burn amount exceeds balance");

        unchecked {
            _balances [account] = accountBalance-amount;
            _totalSupply -= amount;
        }

        emit Transfer (account, address(0), amount);


         _afterTokenTransfer (address(0), account, amount);

    }



    function _beforeTokenTransfer (address from, address to, uint256) internal virtual {}
    function _afterTokenTransfer (address from, address to, uint256) internal virtual {}


}
