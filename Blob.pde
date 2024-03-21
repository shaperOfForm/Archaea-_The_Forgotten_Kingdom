/*import shiffman.box2d.*;

import org.jbox2d.*;
import org.jbox2d.dynamics.*;

import processing.core.*;

public class ConstantVolumeCircle {

    PApplet parent;
    Box2DProcessing box2d;
    Body body;
    float radius;
    float targetVolume;
    float density;

    public ConstantVolumeCircle(PApplet p, Box2DProcessing b2d, float x, float y, float r, float targetVol) {
        parent = p;
        box2d = b2d;
        radius = r;
        targetVolume = targetVol;

        // Calculate density based on target volume and radius
        density = targetVolume / (PConstants.PI * radius * radius);

        // Define body definition
        BodyDef bd = new BodyDef();
        bd.type = BodyType.DYNAMIC;
        bd.position.set(box2d.coordPixelsToWorld(x, y));

        // Create body
        body = box2d.createBody(bd);

        // Create circle shape
        CircleShape circleShape = new CircleShape();
        circleShape.m_radius = box2d.scalarPixelsToWorld(radius);

        // Define fixture definition
        FixtureDef fd = new FixtureDef();
        fd.shape = circleShape;
        fd.density = density;
        fd.friction = 0.3f;
        fd.restitution = 0.5f;

        // Attach fixture to body
        body.createFixture(fd);
    }

    public void display() {
        parent.fill(175);
        parent.stroke(0);
        Vec2 pos = box2d.getBodyPixelCoord(body);
        parent.ellipse(pos.x, pos.y, radius * 2, radius * 2);
    }
}
*/
