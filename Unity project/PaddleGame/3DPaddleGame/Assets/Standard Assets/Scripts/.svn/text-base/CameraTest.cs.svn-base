using UnityEngine;
using System.Collections;

public class CameraTest : MonoBehaviour {
	WebCamDevice[] devices = null;
	string captureCamName;
	WebCamTexture captureTex;
	public Texture2D drawTexture;
	public MeshRenderer renderingMesh; 
	// Use this for initialization
	void Start () {
		
		Debug.Log("iPhone generation: " + iPhone.generation);
		Debug.Log("Device orientation: " + Screen.orientation);
		devices = WebCamTexture.devices;
		
		
		for(int i = 0;i<devices.Length;i++){
			if(!devices[i].isFrontFacing){
				captureCamName = devices[i].name;
			}
			Debug.Log(devices[i].name);
		}
		
		//Some hardcode, Unity doesn't handle properly the resolution of the camera, unfortunately
		//The data are taken from here: https://developer.apple.com/library/ios/DOCUMENTATION/AudioVideo/Conceptual/AVFoundationPG/Articles/04_MediaCapture.html#//apple_ref/doc/uid/TP40010188-CH5-SW2

		Vector2 defaultDeviceCameraResolution = new Vector2(16,16);
		switch(iPhone.generation){
			case iPhoneGeneration.iPad2Gen:
			case iPhoneGeneration.iPad3Gen:
			case iPhoneGeneration.iPad4Gen:
			case iPhoneGeneration.iPodTouch4Gen:
			case iPhoneGeneration.iPodTouch5Gen:
			case iPhoneGeneration.iPhone4:
			case iPhoneGeneration.iPhone4S:
			case iPhoneGeneration.iPhone5:
				defaultDeviceCameraResolution = new Vector2(640,480);//Maximal is 1280,720); Such choice is made in order to avoid big performance loss
				break;
			case iPhoneGeneration.iPhone3GS:
				defaultDeviceCameraResolution = new Vector2(640,480);
				break;
		}
		
	    if(captureCamName!=null){
			captureTex = new WebCamTexture(captureCamName,(int)defaultDeviceCameraResolution.x,(int)defaultDeviceCameraResolution.y,24);
			captureTex.Play();
			drawTexture = new Texture2D((int)defaultDeviceCameraResolution.x,(int)defaultDeviceCameraResolution.y,TextureFormat.RGBA32,false);
			
			Debug.Log("Webtex W & H: " + captureTex.width + " x " + captureTex.height);
			Debug.Log("Webtex requested W & H: " + captureTex.requestedWidth + " x " + captureTex.requestedHeight);
			Debug.Log("Camera pW & pH: " + Camera.main.pixelWidth + " x " + Camera.main.pixelHeight);
			Debug.Log("Video rotation angle: " + captureTex.videoRotationAngle);
		}
		
		//Computing proper scale for the plane in order to avoid 'zoom'
		//Preivous original formula could be found here http://answers.unity3d.com/questions/280467/ipad-camera-aspect-ratio.html#answer-358311
		
		float planeScaleX = (defaultDeviceCameraResolution.x / defaultDeviceCameraResolution.y);//renderingMesh.transform.localScale.x * (Camera.main.pixelWidth / Camera.main.pixelHeight);
		float planeScaleY = 1.0f;//(Camera.main.pixelWidth * renderingMesh.transform.localScale.y) / Camera.main.pixelHeight;
		renderingMesh.transform.localScale = new Vector3(planeScaleX,planeScaleY,renderingMesh.transform.localScale.z);
		
	}
	// Update is called once per frame
	void Update () {
		if(captureTex!=null && captureTex.didUpdateThisFrame)
		{
			drawTexture.SetPixels(captureTex.GetPixels());
			drawTexture.Apply(false);
			renderingMesh.material.mainTexture = drawTexture;
		}
	}
}
