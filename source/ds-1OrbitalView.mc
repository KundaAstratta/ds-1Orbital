import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class ds_1OrbitalView extends WatchUi.WatchFace {

    private var _stars;
    private var _isInSleepMode;

    function initialize() {
        WatchFace.initialize();
        _isInSleepMode = false;
        _stars = new [40];
        for (var i = 0; i < 40; i++) {
            _stars[i] = [Math.rand() % 420, Math.rand() % 420, (Math.rand() % 3) + 1];
        }
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() {
    }

    function onEnterSleep() {
        _isInSleepMode = true;
        WatchUi.requestUpdate();
    }

    function onExitSleep() {
        _isInSleepMode = false;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var cx = width / 2;
        var cy = height / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        drawStarfield(dc);
        
        if (_isInSleepMode) {
            drawQuantumCore(dc, true);
            
            var clock = System.getClockTime();
            var rotation = -((clock.min / 60.0) * Math.PI * 2);
            var rSleep = width * 0.48;
            drawArcSegments(dc, cx, cy, rSleep, rotation, 0x0055AA);

            drawHands(dc, true);
        } else {
            drawQuantumCore(dc, false);
            drawTechRings(dc);
            drawHands(dc, false);
        }
    }

    function onHide() {
    }

    function drawStarfield(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 40; i++) {
            dc.fillCircle(_stars[i][0], _stars[i][1], _stars[i][2]);
        }
    }

    function drawQuantumCore(dc, isSleep) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var cx = width / 2;
        var cy = height / 2;
        var maxRadius = width * 0.25;

        if (isSleep) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(2);
            dc.drawCircle(cx, cy, maxRadius);
            dc.drawCircle(cx, cy, maxRadius * 0.5);
            return;
        }

        var now = System.getTimer();
        
        var pulseBase = (Math.sin(now * 0.002) + 1.0) / 2.0; 
        var rBase = maxRadius * (0.9 + (pulseBase * 0.1));
        dc.setColor(0x0000AA, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, rBase.toNumber());

        var pulseMid = (Math.sin(now * 0.004) + 1.0) / 2.0;
        var rMid = maxRadius * (0.7 + (pulseMid * 0.15));
        dc.setColor(0x0055FF, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, rMid.toNumber());

        var pulseCore = (Math.sin(now * 0.008) + 1.0) / 2.0;
        var rCore = maxRadius * (0.5 + (pulseCore * 0.1));
        dc.setColor(0x00FFFF, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, rCore.toNumber());

        var pulseWhite = (Math.sin(now * 0.012) + 1.0) / 2.0;
        var rWhite = maxRadius * (0.2 + (pulseWhite * 0.05));
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, rWhite.toNumber());

        var wavePhase = (now % 2000) / 2000.0; 
        var waveRadius = maxRadius * 0.4 + (maxRadius * 0.9 * wavePhase);
        var waveWidth = 3 - (wavePhase * 2);
        
        dc.setColor(0x00FFFF, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(waveWidth.toNumber());
        dc.drawCircle(cx, cy, waveRadius.toNumber());
        
        dc.setColor(0x000055, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawCircle(cx, cy, (maxRadius * 1.4).toNumber());
    }

    function drawTechRings(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var cx = width / 2;
        var cy = height / 2;
        var now = System.getTimer();
        
        var angle1 = now * 0.001;
        var r1 = width * 0.35;
        drawPolygonRing(dc, cx, cy, r1, 6, angle1, 0x00AAFF);

        var angle2 = now * -0.0005;
        var r2 = width * 0.42;
        drawPolygonRing(dc, cx, cy, r2, 8, angle2, 0x5555FF);

        var angle3 = now * 0.0002;
        var r3 = width * 0.48;
        drawArcSegments(dc, cx, cy, r3, angle3, 0x0055AA);
    }

    function drawPolygonRing(dc, cx, cy, radius, sides, rotation, color) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        
        var step = (Math.PI * 2) / sides;
        var prevX = cx + radius * Math.cos(rotation);
        var prevY = cy + radius * Math.sin(rotation);

        for (var i = 1; i <= sides; i++) {
            var angle = rotation + (step * i);
            var nextX = cx + radius * Math.cos(angle);
            var nextY = cy + radius * Math.sin(angle);
            
            dc.drawLine(prevX, prevY, nextX, nextY);
            prevX = nextX;
            prevY = nextY;
        }
    }

    function drawArcSegments(dc, cx, cy, radius, rotation, color) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        
        for (var i = 0; i < 4; i++) {
            var start = rotation + (i * (Math.PI / 2));
            var end = start + (Math.PI / 4);
            
            var degStart = Math.toDegrees(start);
            var degEnd = Math.toDegrees(end);

            dc.drawArc(cx, cy, radius, Graphics.ARC_COUNTER_CLOCKWISE, 360 - (degEnd.toNumber() % 360), 360 - (degStart.toNumber() % 360));
        }
    }

    function drawHands(dc, isSleep) {
         var clockTime = System.getClockTime();
         var width = dc.getWidth();
         var height = dc.getHeight();

         var hourHandAngle = Math.PI * 2 * ((clockTime.hour % 12) * 60 + clockTime.min) / (12 * 60.0);
         var minuteHandAngle = Math.PI * 2 * clockTime.min / 60.0;

        var hourHandLength = (width / 2) * 0.6;
        var hourHandWidth = 16; 

        var minuteHandLength = (width / 2) * 0.9;
        var minuteHandWidth = 16; 

        var colorLight = Graphics.COLOR_LT_GRAY;
        var colorDark = Graphics.COLOR_DK_GRAY;
        var colorWhite = Graphics.COLOR_WHITE;

         drawHand(dc, hourHandAngle, hourHandLength, hourHandWidth, colorWhite, colorLight);
         drawHand(dc, minuteHandAngle, minuteHandLength, minuteHandWidth, colorWhite, colorLight);

         dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
         dc.fillCircle(width/2, height/2, 4);
         dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
         dc.fillCircle(width/2, height/2, 2);
    }

    function drawHand(dc, angle, length, width, colorLeft, colorRight) {
        var center = [dc.getWidth() / 2, dc.getHeight() / 2];
        var tailLength = 20;

        var coords = [
            [0, -length],
            [width / 2, 0],
            [0, tailLength],
            [-width / 2, 0]
        ];

        var result = new [4];
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        for (var i = 0; i < 4; i++) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);

            result[i] = [center[0] + x, center[1] + y];
        }

        dc.setColor(colorRight, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([result[0], result[1], result[2], result[3]]);

        dc.setColor(colorLeft, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([result[0], result[3], result[2]]);

        dc.setColor(0xFFD700, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawLine(result[0][0], result[0][1], result[1][0], result[1][1]);
        dc.drawLine(result[1][0], result[1][1], result[2][0], result[2][1]);
        dc.drawLine(result[2][0], result[2][1], result[3][0], result[3][1]);
        dc.drawLine(result[3][0], result[3][1], result[0][0], result[0][1]);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(result[0][0], result[0][1], result[1][0], result[1][1]);
        dc.drawLine(result[1][0], result[1][1], result[2][0], result[2][1]);
        dc.drawLine(result[2][0], result[2][1], result[3][0], result[3][1]);
        dc.drawLine(result[3][0], result[3][1], result[0][0], result[0][1]);
    }

}
