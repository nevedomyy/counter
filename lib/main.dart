import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';


void main() => runApp(Counter());

class Counter extends StatefulWidget{
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> with TickerProviderStateMixin{
  Color _bgrColor = Color.fromRGBO(236, 240, 241, 1.0);
  Color _countColor = Color.fromRGBO(52, 73, 94, 1.0);
  Color _splashColor = Color.fromRGBO(164, 184, 204, 1.0);
  bool _day = true;
  bool _volumeON = true;
  bool _resetBtn = true;
  int _count = 0;
  AudioCache _player;
  AnimationController _controller;
  Animation _animation;

  _CounterState(){_player = AudioCache();_player.load('click.wav');}

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment(){
    if (_count < 99){
      setState(() {
        _count++;
      });
      if (_volumeON){_player.play('click.wav');}
    }
  }

  void _decrement(){
    if (_count > 0){
      setState(() {
        _count--;
      });
    }
  }

  void _reset(){
    setState(() {
      _count = 0;
      _resetBtn = !_resetBtn;
    });
  }

  void _dayNight(){
    _controller.reset();
    setState(() {
      _day = !_day;
      if (_day) {
        _bgrColor = Color.fromRGBO(236, 240, 241, 1.0);
        _countColor = Color.fromRGBO(52, 73, 94, 1.0);
        _splashColor = Color.fromRGBO(164, 184, 204, 1.0);
      }else{
        _bgrColor = Color.fromRGBO(50, 46, 37, 1.0);
        _countColor = Color.fromRGBO(237, 184, 117, 1.0);
        _splashColor = Color.fromRGBO(237, 184, 117, 1.0);
      }
    });
  }

  void _volume(){
    setState(() {
      _volumeON = !_volumeON;
    });
  }

  Widget _btn (Function function, IconData iconFirst, IconData iconSecond, bool triger){
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: _countColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(180.0))
        ),
        child: InkWell(
            onTap: function,
            customBorder: CircleBorder(),
            splashColor: _splashColor,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: AnimatedCrossFade(
                  firstChild: Icon(iconFirst, color: _countColor, size: 35.0),
                  secondChild: Icon(iconSecond, color: _countColor, size: 35.0),
                  crossFadeState: triger ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 200)
              )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return MaterialApp(
      home: Scaffold(
        body: FadeTransition(
          opacity: _animation,
          child: Material(
            color: _bgrColor,
            child: Container(
              padding: EdgeInsets.only(top: 50.0),
              decoration: BoxDecoration(
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _btn(_reset, Icons.loop, Icons.autorenew, _resetBtn),
                      _btn(_dayNight, Icons.brightness_3, Icons.brightness_5, _day),
                      _btn(_volume, Icons.volume_up, Icons.volume_off, _volumeON),
                      _btn(_decrement, Icons.keyboard_backspace, null, true),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Text(
                            '$_count',
                            style: TextStyle(
                                color: _countColor,
                                fontSize: 250.0,
                                fontFamily: 'AdventPro'
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _increment,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        )
      ),
    );
  }
}