import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseCard extends StatelessWidget{
  final Expense expense;
  const ExpenseCard(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(height: 4),
            Row(children: [
              Text('\$${expense.amount.toStringAsFixed(2)}'),
              Spacer(),
              Icon(catToIconMap[expense.category]),
              const SizedBox(width: 8),
              Text(expense.formattedDate),
            ],),
          ],
        ),
      ),
    );
  }

}


class ExpensesColumn extends StatelessWidget {
  final List<Expense> expList;
  final void Function(Expense) onExpRemoved;

  const ExpensesColumn({super.key, required this.expList, required this.onExpRemoved});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expList.length, 
      itemBuilder:(context, index) => Dismissible(
        key: ValueKey(expList[index]),
        onDismissed: (direction) => onExpRemoved(expList[index]),
        child: ExpenseCard(expList[index])
      ),
    );
  }

}


class ExpenseInputPage extends StatefulWidget {
  final void Function(Expense epx) onAddExp;

  const ExpenseInputPage({required this.onAddExp, super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseInputPageState();
  
}

class _ExpenseInputPageState extends State<ExpenseInputPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;

  // void _presentDatePicker() {
  //   final now = DateTime.now();
  //   final first = DateTime(now.year - 10, now.month, now.day);
  //   showDatePicker(context: context, initialDate: now, firstDate: first, lastDate: now).then((value) {
      
  //   },);
  // }

  void _presentDatePickerAsync() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 10, now.month, now.day);
    final selectedDate = await showDatePicker(
      context: context, initialDate: now, firstDate: first, lastDate: now
    );
    setState(() => _selectedDate = selectedDate);
  }

  void _submitExpense(title, amount) {
    if (title == '') {
      return;
    }
    if (amount < 0) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategory == null) {
      return;
    }
    widget.onAddExp(Expense(amount: amount, title: title, date: _selectedDate!, category: _selectedCategory!));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Title'),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _amountController,
            decoration: InputDecoration(
              label: Text('Amount'),
              icon: Icon(Icons.attach_money),
            ),
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name.toUpperCase() ),
                  )
                  ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: _presentDatePickerAsync,
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _submitExpense(_titleController.text, double.parse(_amountController.text));
                },
                child: Text('Submit Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
}

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  final List<Expense> _testExpenses = [
    Expense(title: 'Flutter Course', amount: 19.99, date: DateTime.now(), category: Category.work),
    Expense(title: 'Cinema', amount: 15.89, date: DateTime.now(), category: Category.leisure),
  ];

  void _addExpense(Expense exp) {
    setState(() {
      _registeredExpenses.add(exp);
    });
  }

  void _removeExp(Expense exp) {
    final int index = _registeredExpenses.indexOf(exp);
    setState(() {
      _registeredExpenses.remove(exp);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Text('Expense deleted'),
      action: SnackBarAction(
        label: 'Undo', 
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(index, exp);
          });
        })
    ));
  }

  void _openAddExpOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ExpenseInputPage(onAddExp: _addExpense,),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mainArea = _registeredExpenses == []
    ? const Center(child: Text('No expenses'))
    : Column(
        children: [
          Text('chart'),
          Expanded(child: ExpensesColumn(expList: _registeredExpenses, onExpRemoved: _removeExp,),),
        ],
      );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openAddExpOverlay,
            icon: const Icon(Icons.add),
          )
        ]
      ),
      body: mainArea,
    );
  }

}