# PLANNING SIMULATION
function download_planning_map() {
    if [ ! -f ~/autoware_map/sample-map-planning.zip ]; then
        gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1499_nsbUbIeturZaDj7jhUownh5fvXHd'
        unzip -d ~/autoware_map ~/autoware_map/sample-map-planning.zip
    fi
}
alias awf-launch-planning-sim='download_planning_map&&ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$HOME/autoware_map/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'

# ROSBAG REPLAY SIMULATION
function download_rosbag_map() {
    if [ ! -f ~/autoware_map/sample-map-rosbag.zip ]; then
        gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1A-8BvYRX3DhSzkAnOcGWFw5T30xTlwZI'
        unzip -d ~/autoware_map/ ~/autoware_map/sample-map-rosbag.zip
    fi
}

function download_rosbag_artifacts() {
    if [ ! -d ~/autoware_data ]; then
        # yabloc_pose_initializer
        mkdir -p ~/autoware_data/yabloc_pose_initializer/
        wget -P ~/autoware_data/yabloc_pose_initializer/ \
            https://s3.ap-northeast-2.wasabisys.com/pinto-model-zoo/136_road-segmentation-adas-0001/resources.tar.gz
        tar -xf ~/autoware_data/yabloc_pose_initializer/resources.tar.gz \
            -C ~/autoware_data/yabloc_pose_initializer/

        # image_projection_based_fusion
        mkdir -p ~/autoware_data/image_projection_based_fusion/
        wget -P ~/autoware_data/image_projection_based_fusion/ \
            https://awf.ml.dev.web.auto/perception/models/pointpainting/v4/pts_voxel_encoder_pointpainting.onnx \
            https://awf.ml.dev.web.auto/perception/models/pointpainting/v4/pts_backbone_neck_head_pointpainting.onnx

        # lidar_apollo_instance_segmentation
        mkdir -p ~/autoware_data/lidar_apollo_instance_segmentation/
        wget -P ~/autoware_data/lidar_apollo_instance_segmentation/ \
            https://awf.ml.dev.web.auto/perception/models/lidar_apollo_instance_segmentation/vlp-16.onnx \
            https://awf.ml.dev.web.auto/perception/models/lidar_apollo_instance_segmentation/hdl-64.onnx \
            https://awf.ml.dev.web.auto/perception/models/lidar_apollo_instance_segmentation/vls-128.onnx

        # lidar_centerpoint
        mkdir -p ~/autoware_data/lidar_centerpoint/
        wget -P ~/autoware_data/lidar_centerpoint/ \
            https://awf.ml.dev.web.auto/perception/models/centerpoint/v2/pts_voxel_encoder_centerpoint.onnx \
            https://awf.ml.dev.web.auto/perception/models/centerpoint/v2/pts_backbone_neck_head_centerpoint.onnx \
            https://awf.ml.dev.web.auto/perception/models/centerpoint/v2/pts_voxel_encoder_centerpoint_tiny.onnx \
            https://awf.ml.dev.web.auto/perception/models/centerpoint/v2/pts_backbone_neck_head_centerpoint_tiny.onnx


        # tensorrt_yolo
        mkdir -p ~/autoware_data/tensorrt_yolo/
        wget -P ~/autoware_data/tensorrt_yolo/ \
            https://awf.ml.dev.web.auto/perception/models/yolov3.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolov4.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolov4-tiny.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolov5s.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolov5m.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolov5l.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolov5x.onnx \
            https://awf.ml.dev.web.auto/perception/models/coco.names

        # tensorrt_yolox
        mkdir -p ~/autoware_data/tensorrt_yolox/
        wget -P ~/autoware_data/tensorrt_yolox/ \
            https://awf.ml.dev.web.auto/perception/models/yolox-tiny.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolox-sPlus-opt.onnx \
            https://awf.ml.dev.web.auto/perception/models/yolox-sPlus-opt.EntropyV2-calibration.table \
            https://awf.ml.dev.web.auto/perception/models/object_detection_yolox_s/v1/yolox-sPlus-T4-960x960-pseudo-finetune.onnx \
            https://awf.ml.dev.web.auto/perception/models/object_detection_yolox_s/v1/yolox-sPlus-T4-960x960-pseudo-finetune.EntropyV2-calibration.table \
            https://awf.ml.dev.web.auto/perception/models/label.txt

        # traffic_light_classifier
        mkdir -p ~/autoware_data/traffic_light_classifier/
        wget -P ~/autoware_data/traffic_light_classifier/ \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/traffic_light_classifier_mobilenetv2_batch_1.onnx \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/traffic_light_classifier_mobilenetv2_batch_4.onnx \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/traffic_light_classifier_mobilenetv2_batch_6.onnx \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/traffic_light_classifier_efficientNet_b1_batch_1.onnx \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/traffic_light_classifier_efficientNet_b1_batch_4.onnx \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/traffic_light_classifier_efficientNet_b1_batch_6.onnx \
            https://awf.ml.dev.web.auto/perception/models/traffic_light_classifier/v2/lamp_labels.txt

        # traffic_light_fine_detector
        mkdir -p ~/autoware_data/traffic_light_fine_detector/
        wget -P ~/autoware_data/traffic_light_fine_detector/ \
            https://awf.ml.dev.web.auto/perception/models/tlr_yolox_s/v2/tlr_yolox_s_batch_1.onnx \
            https://awf.ml.dev.web.auto/perception/models/tlr_yolox_s/v2/tlr_yolox_s_batch_4.onnx \
            https://awf.ml.dev.web.auto/perception/models/tlr_yolox_s/v2/tlr_yolox_s_batch_6.onnx \
            https://awf.ml.dev.web.auto/perception/models/tlr_yolox_s/v2/tlr_labels.txt

        # traffic_light_ssd_fine_detector
        mkdir -p ~/autoware_data/traffic_light_ssd_fine_detector/
        wget -P ~/autoware_data/traffic_light_ssd_fine_detector/ \
            https://awf.ml.dev.web.auto/perception/models/mb2-ssd-lite-tlr.onnx \
            https://awf.ml.dev.web.auto/perception/models/voc_labels_tl.txt

        # tvm_utility
        mkdir -p ~/autoware_data/tvm_utility/models/yolo_v2_tiny
        wget -P ~/autoware_data/tvm_utility/ \
            https://autoware-modelzoo.s3.us-east-2.amazonaws.com/models/3.0.0-20221221/yolo_v2_tiny-x86_64-llvm-3.0.0-20221221.tar.gz
        tar -xf ~/autoware_data/tvm_utility/yolo_v2_tiny-x86_64-llvm-3.0.0-20221221.tar.gz \
            -C ~/autoware_data/tvm_utility/models/yolo_v2_tiny/

        # lidar_centerpoint_tvm
        mkdir -p ~/autoware_data/lidar_centerpoint_tvm/models/centerpoint_encoder
        mkdir -p ~/autoware_data/lidar_centerpoint_tvm/models/centerpoint_backbone
        wget -P ~/autoware_data/lidar_centerpoint_tvm/ \
            https://autoware-modelzoo.s3.us-east-2.amazonaws.com/models/3.0.0-20221221/centerpoint_encoder-x86_64-llvm-3.0.0-20221221.tar.gz \
            https://autoware-modelzoo.s3.us-east-2.amazonaws.com/models/3.0.0-20221221/centerpoint_backbone-x86_64-llvm-3.0.0-20221221.tar.gz
        tar -xf ~/autoware_data/lidar_centerpoint_tvm/centerpoint_encoder-x86_64-llvm-3.0.0-20221221.tar.gz \
            -C ~/autoware_data/lidar_centerpoint_tvm/models/centerpoint_encoder
        tar -xf ~/autoware_data/lidar_centerpoint_tvm/centerpoint_backbone-x86_64-llvm-3.0.0-20221221.tar.gz \
            -C ~/autoware_data/lidar_centerpoint_tvm/models/centerpoint_backbone

        # lidar_apollo_segmentation_tvm
        mkdir -p ~/autoware_data/lidar_apollo_segmentation_tvm/models/baidu_cnn
        wget -P ~/autoware_data/lidar_apollo_segmentation_tvm/ \
            https://autoware-modelzoo.s3.us-east-2.amazonaws.com/models/3.0.0-20221221/baidu_cnn-x86_64-llvm-3.0.0-20221221.tar.gz
        tar -xf ~/autoware_data/lidar_apollo_segmentation_tvm/baidu_cnn-x86_64-llvm-3.0.0-20221221.tar.gz \
            -C ~/autoware_data/lidar_apollo_segmentation_tvm/models/baidu_cnn
    fi
}
alias awf-launch-sample-rosbag-sim='download_rosbag_artifacts&&download_rosbag_map&&ros2 launch autoware_launch logging_simulator.launch.xml map_path:=$HOME/autoware_map/sample-map-rosbag vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'

# play sample rosbag
function download_rosbag_file() {
    if [ ! -f ~/autoware_map/sample-rosbag.zip ]; then
        gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1VnwJx9tI3kI_cTLzP61ktuAJ1ChgygpG'
        unzip -d ~/autoware_map/ ~/autoware_map/sample-rosbag.zip
    fi
}
alias awf-play-sample-rosbag='download_rosbag_file&&ros2 bag play ~/autoware_map/sample-rosbag/sample.db3 -r 0.35 -s sqlite3'
