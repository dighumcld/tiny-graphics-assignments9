
import numpy as np
import tensorflow as tf
import cv2
import time
import sys
import matplotlib.pyplot as plt

DEBUG = False

class YOLO_TF:
    weights_file = 'YOLO_tiny.ckpt'
    alpha = 0.1
    threshold = 0.05
    iou_threshold = 0.2
    num_class = 20
    num_box = 2
    grid_size = 7
    classes =  ["aeroplane", "bicycle", "bird", "boat", "bottle", "bus", "car", "cat", "chair", "cow", "diningtable", "dog", "horse", "motorbike", "person", "pottedplant", "sheep", "sofa", "train","tvmonitor"]

    w_img = 640
    h_img = 480

    def __init__(self):
        self.build_networks()

    def build_networks(self):
        self.x = tf.placeholder('float32',[None,448,448,3])
        self.conv_1 = self.conv_layer(1,self.x,16,3,1)
        self.pool_2 = self.pooling_layer(2,self.conv_1,2,2)
        self.conv_3 = self.conv_layer(3,self.pool_2,32,3,1)
        self.pool_4 = self.pooling_layer(4,self.conv_3,2,2)
        self.conv_5 = self.conv_layer(5,self.pool_4,64,3,1)
        self.pool_6 = self.pooling_layer(6,self.conv_5,2,2)
        self.conv_7 = self.conv_layer(7,self.pool_6,128,3,1)
        self.pool_8 = self.pooling_layer(8,self.conv_7,2,2)
        self.conv_9 = self.conv_layer(9,self.pool_8,256,3,1)
        self.pool_10 = self.pooling_layer(10,self.conv_9,2,2)
        self.conv_11 = self.conv_layer(11,self.pool_10,512,3,1)
        self.pool_12 = self.pooling_layer(12,self.conv_11,2,2)
        self.conv_13 = self.conv_layer(13,self.pool_12,1024,3,1)
        self.conv_14 = self.conv_layer(14,self.conv_13,1024,3,1)
        self.conv_15 = self.conv_layer(15,self.conv_14,1024,3,1)
        self.fc_16 = self.fc_layer(16,self.conv_15,256,flat=True,linear=False)
        self.fc_17 = self.fc_layer(17,self.fc_16,4096,flat=False,linear=False)
        #skip dropout_18
        self.fc_19 = self.fc_layer(19,self.fc_17,1470,flat=False,linear=True)
        self.sess = tf.Session()
        self.sess.run(tf.global_variables_initializer())
        self.saver = tf.train.Saver()
        self.saver.restore(self.sess,self.weights_file)

        if DEBUG: print("Loading complete!" + '\n')

    def conv_layer(self,idx,inputs,filters,size,stride):
        channels = inputs.get_shape()[3]
        weight = tf.Variable(tf.truncated_normal([size,size,int(channels),filters], stddev=0.1))
        biases = tf.Variable(tf.constant(0.1, shape=[filters]))

        pad_size = size//2
        pad_mat = np.array([[0,0],[pad_size,pad_size],[pad_size,pad_size],[0,0]])
        inputs_pad = tf.pad(inputs,pad_mat)

        conv = tf.nn.conv2d(inputs_pad, weight, strides=[1, stride, stride, 1], padding='VALID',name=str(idx)+'_conv')
        conv_biased = tf.add(conv,biases,name=str(idx)+'_conv_biased')

        if DEBUG: print('  Layer  %d : Type = Conv, Size = %d * %d, Stride = %d, Filters = %d, Input channels = %d' % (idx,size,size,stride,filters,int(channels)))

        return tf.maximum(self.alpha*conv_biased,conv_biased,name=str(idx)+'_leaky_relu')

    def pooling_layer(self,idx,inputs,size,stride):
        if DEBUG: print('  Layer  %d : Type = Pool, Size = %d * %d, Stride = %d' % (idx,size,size,stride))

        return tf.nn.max_pool(inputs, ksize=[1, size, size, 1],strides=[1, stride, stride, 1], padding='SAME',name=str(idx)+'_pool')

    def fc_layer(self,idx,inputs,hiddens,flat = False,linear = False):
        input_shape = inputs.get_shape().as_list()
        if flat:
            dim = input_shape[1]*input_shape[2]*input_shape[3]
            inputs_transposed = tf.transpose(inputs,(0,3,1,2))
            inputs_processed = tf.reshape(inputs_transposed, [-1,dim])
        else:
            dim = input_shape[1]
            inputs_processed = inputs
        weight = tf.Variable(tf.truncated_normal([dim,hiddens], stddev=0.1))
        biases = tf.Variable(tf.constant(0.1, shape=[hiddens]))
        if DEBUG : print('  Layer  %d : Type = Full, Hidden = %d, Input dimension = %d, Flat = %d, Activation = %d' % (idx,hiddens,int(dim),int(flat),1-int(linear)))
        if linear : return tf.add(tf.matmul(inputs_processed,weight),biases,name=str(idx)+'_fc')
        ip = tf.add(tf.matmul(inputs_processed,weight),biases)
        return tf.maximum(self.alpha*ip,ip,name=str(idx)+'_fc')

    def detect_from_cvmat(self,img):
        s = time.time()
        self.h_img,self.w_img,_ = img.shape
        img_resized = cv2.resize(img, (448, 448))
        img_resized_np = np.asarray(img_resized)
        inputs = np.zeros((1,448,448,3),dtype='float32')
        inputs[0] = (img_resized_np/255.0)*2.0-1.0
        in_dict = {self.x: inputs}
        net_output = self.sess.run(self.fc_19,feed_dict=in_dict)

        result = self.interpret_output(net_output[0])
        strtime = str(time.time()-s)
        if DEBUG : print('Elapsed time : ' + strtime + ' secs' + '\n')

        return result

    def detect_from_file(self,filename):
        if self.DEBUG : print('Detect from ' + filename)
        img = cv2.imread(filename)
        img_RGB = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
        return self.detect_from_cvmat(img_RGB)

    def interpret_output(self,output):
        probs = np.zeros((7,7,2,20))
        class_probs = np.reshape(output[0:980],(7,7,20))
        scales = np.reshape(output[980:1078],(7,7,2))
        boxes = np.reshape(output[1078:],(7,7,2,4))
        offset = np.transpose(np.reshape(np.array([np.arange(7)]*14),(2,7,7)),(1,2,0))

        boxes[:,:,:,0] += offset
        boxes[:,:,:,1] += np.transpose(offset,(1,0,2))
        boxes[:,:,:,0:2] = boxes[:,:,:,0:2] / 7.0
        boxes[:,:,:,2] = np.multiply(boxes[:,:,:,2],boxes[:,:,:,2])
        boxes[:,:,:,3] = np.multiply(boxes[:,:,:,3],boxes[:,:,:,3])

        boxes[:,:,:,0] *= self.w_img
        boxes[:,:,:,1] *= self.h_img
        boxes[:,:,:,2] *= self.w_img
        boxes[:,:,:,3] *= self.h_img